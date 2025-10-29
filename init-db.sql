DO $$
BEGIN
    GRANT ALL PRIVILEGES ON DATABASE taskdb TO taskuser;
    GRANT ALL PRIVILEGES ON SCHEMA public TO taskuser;
    GRANT CREATE ON SCHEMA public TO taskuser;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO taskuser;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO taskuser;
    RAISE NOTICE 'Permissões configuradas com sucesso para o usuário taskuser';
END
$$;

