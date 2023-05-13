import fastify from 'fastify';
import path from 'path';
import fastifyStatic = require("@fastify/static");

const server = fastify();

// Serve static files
server.register(fastifyStatic, {
  root: path.join(__dirname, 'public'),
  prefix: '/',
});

// Define the route for the index.html file
server.get('/', (request, reply) => {
  reply.sendFile('index.html');
});

// Start the server
server.listen({ port: 3003 }, (err, address) => {
  if (err) throw err;
  console.log(`Server listening on ${address}`);
});