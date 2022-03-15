import express = require("express");
import session from 'express-session';
import fileUpload from 'express-fileupload';
import cors from 'cors';
// import fs from "fs";
import http, { Server } from "http";
// import ws from 'ws';
import compression from 'compression';
import {createClient} from 'redis';
import createStore from 'connect-redis';
import dotenv from 'dotenv';
import {v4} from 'uuid';
import { send } from "process";

dotenv.config();

const secret  = process.env.API_COOKIE_SECRET ?? 'definitely-a-secret';

var api = express();

function shouldCompress (req:any, res:any) {
  if (req.headers['x-no-compression']) {
    // don't compress responses with this request header
    return false;
  }
  // fallback to standard filter function
  return compression.filter(req, res)
}

api.use(compression({filter:shouldCompress}));
api.use(cors());
api.disable('x-powered-by');
api.use(express.json());
api.use(express.urlencoded({extended:true}));
api.set('trust proxy', 1);
var httpServer: Server;

api.use('/api/files/upload', fileUpload({
	debug:false,
}));

if(process.env.API_COOKIE_SECRET === undefined){
	throw new Error("[API] Cookie Secret Undefined. Please set in .env");
}

const RedisStore = createStore(session);
const sessionCache = createClient({
	legacyMode:true,
	socket:{
		host:process.env.CACHE_HOST,
		port:Number.parseInt(process.env.CACHE_PORT ?? "6379")
	},
	password:process.env.CACHE_PASS
});
sessionCache.connect().catch((e)=>{throw new Error(e)});


const cache = createClient({
	socket:{
		host:process.env.CACHE_HOST,
		port:Number.parseInt(process.env.CACHE_PORT ?? "6379")
	},
	password:process.env.CACHE_PASS
});
cache.connect().catch((e)=>{throw new Error(e)});

const queueFiles = async (files:any, {arg1, arg2}:any)=>{
	const keys = [] as {name:string, fileId:string}[];
	Object.keys(files).forEach(async(key)=>{
		const file = files[key];
		if(!file.name){
			file.forEach(async ({name, data, fileId}:any)=>{
				const hash = v4();
				keys.push({fileId:hash, name});
				await cache.hSet(fileId, 'name', name);
				await cache.hSet(fileId, 'data', data.toString('hex'));
				await cache.expire(fileId, 1200);
			})
		}else{
			const hash = v4();
			keys.push({fileId:hash, name:file.name});
			await cache.hSet(file.fileId, 'name', file.name);
			await cache.hSet(file.fileId, 'data', file.data.toString('hex'));
			await cache.expire(file.fileId, 1200);
		}
	});

	return keys;
};

const getFile = async (id:string) =>{
	return await cache.HGETALL(id);
};

const sessionMiddleware = session({
	store: new RedisStore({ client: sessionCache as any }),
	secret,
	resave: false,
	saveUninitialized: false,
	cookie:{
		secure: false,
		httpOnly: true,
		maxAge: 600000 //10 minutes (ms)
	}
})
api.use(sessionMiddleware);

api.use(function (req, res, next) {
  if (!req.session) {
    return next(new Error("Oops!")) // handle error
  }
  next() // otherwise continue
});

export const start = () => {
	console.log(`[API] Starting Server on ${process.env.API_PORT}`);
	httpServer = http.createServer(api);
	api.listen(process.env.API_PORT ?? 8085);

	api.post('/api/files/upload', async (req:any, res) => {
    try {
			if(!req.files) {
				res.send({
					status: false,
					message: 'Upload failed. No files attached.'
				});
				return;
			}
			let fileKeys = await queueFiles(req.files, req.body);
			req.session.files = fileKeys;
			res.send({
				status: true,
				message: 'Files uploaded',
				files: fileKeys
			});
    } catch (err) {
			res.status(500).send(err);
    }
	});

	api.get('/api/files/session', async (req:any, res)=>{
		res.send(req.session.files);
	});

	api.get('/api/files/download', async (req, res) => {
		if(!req.query.fileId){
			res.send({status:false, message: "Filed to download file."});
			return;
		}
		//TODO: Implement zip compression before reaching compression middleware if multiple files 
		//(send together as zip instead of multiple requests)
		let id = req.query.fileId as string;
		let file = await getFile(id);
		res.attachment(`${file?.name ?? "File"}`);
		res.send(file.data);
	});
}

const shutdown = () => {
	httpServer.close(() => {
		process.exit();
	});
};

process.on("SIGTERM", shutdown);

process.on("SIGINT", shutdown);
start();

const testCache = async ()=>{
	await cache.HSET('testKey', 'testField', 'testValue');
	let val = await cache.HGETALL('testKey');
	console.log(JSON.stringify(val,null,2));
}
testCache();