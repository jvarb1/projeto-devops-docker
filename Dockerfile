# Estágio 1: Build
FROM python:3.11-alpine AS builder

# Instalar dependências de build
RUN apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev \
    python3-dev \
    libffi-dev

# Criar diretório de trabalho
WORKDIR /app

# Copiar arquivo de dependências
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --user -r requirements.txt

# Estágio 2: Runtime
FROM python:3.11-alpine AS runtime

# Instalar apenas runtime dependencies do PostgreSQL
RUN apk add --no-cache \
    postgresql-libs \
    && rm -rf /var/cache/apk/*

# Criar usuário não-root para executar a aplicação
RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser

# Definir diretório de trabalho
WORKDIR /app

# Copiar dependências instaladas do estágio de build
COPY --from=builder /root/.local /home/appuser/.local

# Copiar código da aplicação
COPY --chown=appuser:appuser app /app/app

# Configurar PATH para incluir .local/bin
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

# Trocar para usuário não-root
USER appuser

# Expor porta da aplicação
EXPOSE 8000

# Comando para executar a aplicação
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

