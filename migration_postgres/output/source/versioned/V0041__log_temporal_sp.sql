CREATE TABLE denuncias.log_guardar_denuncia_interesquema
(
id INT IDENTITY PRIMARY KEY,
ts DATETIME2,
id_funcionario INT,
in_json NVARCHAR(MAX),
out_json NVARCHAR(MAX),
error NVARCHAR(MAX)
)
GO