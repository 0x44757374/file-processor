# File Processor Template
> This template, and documentation are In Progress

There are many web applications that handle file conversions and modifications.</br>
This is a template to allow an easy starting point for that type of application server with high modularity and flexibility.</br></br>
Purpose: Serve a webserver with a `file upload ➡ process file  ➡ download processed file` pipeline. </br></br>


# Table of Contents
- [Overview](#overview)
- [Getting Started](#getting-started)
	-	[Initial Steps](#initial-steps)
	- [Building](#building-components)
	- [Running](#running-components)
- [Testing](#testing)
- [CLI](#cli)

# Overview

## Primary Technologies Used
[NGINX](https://www.nginx.com/wp-content/uploads/2020/05/NGINX-product-icon.svg | width=80 | height=30)
[ModSec](https://github.com/SpiderLabs/ModSecurity/raw/v3/master/others/modsec.png | height=30)


[SolidJS](https://www.solidjs.com/img/logo/without-wordmark/logo.svg width=80 | height=30)
[Docker](https://www.docker.com/sites/default/files/d8/styles/role_icon/public/2019-07/horizontal-logo-monochromatic-white.png | height=30)
[NodeJS](https://nodejs.org/static/images/logo.svg | width=80 |  height=30)
[Redis](https://redis.io/images/redis-white.png | width=80 |  height=30)


## Structure


|Component|Folder|Purpose|
|---------|------|-------|
| `Server` | [./server](./server/) | Reverse Proxy to route traffic to/between components | 
| `CLI` | [./scripts](./scripts/) | Bash CLI for simple, consistent commands (`build`, `start`, `stop`, `logs`) |
| `API` | [./api](./api/) | NodeJS + Express API for handling `upload`, `download`, `queue` | 
| `App` | [./app](./app/) | SolidJS + Express Web App for User Interface | 
| `Cache` | [./cache](./cache/) | Redis Database for API data | 

[👆 Back to Top](#file-processor-template)
___

# Getting Started
Requirements: 
- Bash
- Docker

## Initial Steps
- Clone the repository, then enter the project folder
- Navigate to the scripts folder, and run the init script
```bash
cd <PROJECT_NAME>/scripts
chmod u+x init.sh
```
> zsh users may need to start a new shell instance (exit, and restart your terminal)

## Building Components
Components can run as networked containers, standalone containers, local builds, or any combination thereof.</br></br>

**Build Project (All Images)** | `fpserv build`
> Run build command with no arguments

</br>

**Build an individual component** | `fpserv build [component-name1, component-name2]`
> Build [n] components by name, ie: `fpserv build api app`

</br>

## Running Components
Each component can also start/stop independently


**Start/Stop Project (All Images)** | `fpserv start` or `fpserv stop`
> Run start/stop command with no arguments

</br>

**Start/Stop an individual component** | `fpserv start [name1, name2, ...]`
> Build [n] components by name, ie: `fpserv start cache` or `fpserv start cache`

</br>

[👆 Back to Top](#file-processor-template)
___

# Testing

> Dev/local build instructions soon

After building and running the containers (or running them individually)
open [`http://localhost:80`](http://localhost:80) in your browser.



[👆 Back to Top](#file-processor-template)
___

# CLI
> The CLI is primarily a bash wrapper around docker compose. You can run any container(s) with docker compose, or build them locally. This is just for convenience. Prune as you see fit/need.

```bash 
$ fpserv [command] [...args, ...options]
```
| Command | Arg Count | Args | Description | Examples |
| -- |--| --|  --| --|
| `build` | 0+ | api</br>app</br>server</br>cache |  	 Build specified image(s) |	`$ fpserv build api app`</br>`$ fpserv build` | 
| `start` | 0+ | api</br>app</br>server</br>cache |   Start specified container(s) |	`$ fpserv start api`</br>`$ fpserv start` | 
| `stop` | 0+ | api</br>app</br>server</br>cache |  	Stop specified container(s) |	`$ fpserv stop api`</br> `$ fpserv stop` |
| `logs` | 1+ | api</br>app</br>server</br>cache |   Print specified container logs |	`$ fpserv logs server` | 
| `env` | 0 | -- |  Create boilerplate .env file |	`$ fpserv env` |
| `status` | 0 | -- |  fpserv container status |	`$ fpserv status` | 
| `help` | 0 | -- |  fpserv help menu |	`$ fpserv help` |


[👆 Back to Top](#file-processor-template)

___