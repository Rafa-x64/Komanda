import { Client } from "pg";
import * as fs from "fs";

async function run() {
  const client = new Client({
    host: "localhost",
    port: 5432,
    user: "postgres",
    password: "postgres",
    database: "komanda_db",
  });

  try {
    await client.connect();
    
    // Get tables
    const res = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name;
    `);

    const schema: any = {};
    for (const row of res.rows) {
      const tableName = row.table_name;
      
      // Get columns for each table
      const colRes = await client.query(`
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = $1;
      `, [tableName]);
      
      schema[tableName] = colRes.rows;
    }
    fs.writeFileSync("schema_output.json", JSON.stringify(schema, null, 2));
    console.log("Schema written to schema_output.json");
  } catch (error: any) {
    fs.writeFileSync("schema_output.json", JSON.stringify({ error: error.message }, null, 2));
    console.error("Error written to schema_output.json");
  } finally {
    await client.end();
  }
}

run();
