require('dotenv').config();
const neo4j = require('neo4j-driver');

const driver = neo4j.driver(
  process.env.NEO4J_URI,
  neo4j.auth.basic(process.env.NEO4J_USER, process.env.NEO4J_PASSWORD)
);

async function connectNeo4j() {
  try {
    const session = driver.session({ 
      database: process.env.NEO4J_DATABASE || 'neo4j'
    });
    await session.run('RETURN "Connected"'); //truy van cypher
    console.log('Neo4j_Connected');
    await session.close();
  } catch (err) {
    console.error('Neo4j_Inconnected', err);
  }
}
//export nhieu thu de tai su dung,.. dong neo4j...
module.exports = { driver, connectNeo4j };
