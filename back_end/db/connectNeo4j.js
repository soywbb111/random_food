const neo4j = require('neo4j-driver');

const driver = neo4j.driver(
  'bolt://localhost:7687',      
  neo4j.auth.basic('neo4j', 'Hoangnhung2312') 
);

async function connectNeo4j() {
  try {
    const session = driver.session({ database: 'neo4j' });
    await session.run('RETURN "Connected"'); //truy van cypher
    console.log('Neo4j_Connected');
    await session.close();
  } catch (err) {
    console.error('Neo4j_Inconnected', err);
  }
}
//export nhieu thu de tai su dung,.. dong neo4j...
module.exports = { driver, connectNeo4j };