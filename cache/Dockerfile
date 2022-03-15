FROM redis as CACHE
CMD redis-server --save 20 1 --loglevel warning --requirepass ${CACHE_PASS} --port ${CACHE_PORT}