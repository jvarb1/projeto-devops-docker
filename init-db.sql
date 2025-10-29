-- Script de inicialização do banco de dados
-- Este script é executado automaticamente na primeira inicialização do container PostgreSQL
-- 
-- Nota: O usuário e banco já são criados automaticamente pelo PostgreSQL através das
-- variáveis de ambiente POSTGRES_USER, POSTGRES_DB e POSTGRES_PASSWORD.
-- Este script garante permissões adicionais e configurações de segurança.

-- Garantir que o usuário taskuser tenha todas as permissões necessárias
DO $$
BEGIN
    -- Garantir permissões no banco de dados
    GRANT ALL PRIVILEGES ON DATABASE taskdb TO taskuser;
    
    -- Garantir permissões no schema public
    GRANT ALL PRIVILEGES ON SCHEMA public TO taskuser;
    GRANT CREATE ON SCHEMA public TO taskuser;
    
    -- Configurar permissões padrão para objetos futuros
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO taskuser;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO taskuser;
    
    RAISE NOTICE 'Permissões configuradas com sucesso para o usuário taskuser';
END
$$;

