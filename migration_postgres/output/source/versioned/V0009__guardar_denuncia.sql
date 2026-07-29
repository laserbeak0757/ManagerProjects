CREATE TABLE denuncias.log_guardar_denuncia
(
id_log_guardar_denuncia INT IDENTITY PRIMARY KEY,
ts_utc_inicio DATETIME NOT NULL,
client_net_address NVARCHAR(100),
[system_user] NVARCHAR(128),
[current_user] NVARCHAR(128),
in_denuncia_json NVARCHAR(MAX) NULL,
out_resp_json NVARCHAR(MAX) NULL,
ts_utc_fin DATETIME NULL,
error NVARCHAR(MAX) NULL
)