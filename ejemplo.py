from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("ConexionPostgres") \
    .config("spark.jars", "/opt/spark/jars/postgresql-42.7.3.jar") \
    .getOrCreate()

jdbc_url = "jdbc:postgresql://postgres:5432/pruebas_db"
connection_props = {
    "user": "usuario",
    "password": "clave_segura",
    "driver": "org.postgresql.Driver"
}

# DataFrame de ejemplo
datos = [("María", 29), ("Carlos", 35)]
df = spark.createDataFrame(datos, ["nombre", "edad"])
df.show()


# # Escritura en PostgreSQL
df.write.jdbc(url=jdbc_url, table="personas", mode="overwrite", properties=connection_props)

# Lectura desde PostgreSQL
df2 = spark.read.jdbc(url=jdbc_url, table="personas", properties=connection_props)
df2.show()