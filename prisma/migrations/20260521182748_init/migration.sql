/*
  Warnings:

  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "StatusProduto" AS ENUM ('disponivel', 'descontinuado');

-- CreateEnum
CREATE TYPE "TipoUsuario" AS ENUM ('cliente', 'administrador', 'anfitriao');

-- CreateEnum
CREATE TYPE "TipoAdmin" AS ENUM ('admin', 'moderador', 'super_admin');

-- CreateEnum
CREATE TYPE "StatusConta" AS ENUM ('ativo', 'inativo', 'bloqueado', 'pendente');

-- CreateEnum
CREATE TYPE "TipoProduto" AS ENUM ('experiencia', 'hospedagem', 'pacote');

-- CreateEnum
CREATE TYPE "StatusReserva" AS ENUM ('pendente', 'confirmada', 'cancelada', 'concluida');

-- CreateEnum
CREATE TYPE "FormaPagamento" AS ENUM ('cartao', 'pix', 'boleto', 'dinheiro');

-- DropTable
DROP TABLE "User";

-- CreateTable
CREATE TABLE "registro_clientes" (
    "id" SERIAL NOT NULL,
    "nome_completo" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "cpf" VARCHAR(14),
    "senha_hash" VARCHAR(255) NOT NULL,
    "tipo_usuario" "TipoUsuario" NOT NULL DEFAULT 'cliente',
    "data_criacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_atualizacao" TIMESTAMP(3) NOT NULL,
    "status_conta" "StatusConta" NOT NULL DEFAULT 'ativo',
    "data_nascimento" TIMESTAMP(3),
    "telefone" VARCHAR(20),
    "avatar_url" TEXT,
    "bio" TEXT,
    "ultimo_login" TIMESTAMP(3),

    CONSTRAINT "registro_clientes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "produtos" (
    "id" SERIAL NOT NULL,
    "categoria" VARCHAR(50) DEFAULT 'geral',
    "nome" VARCHAR(255) NOT NULL,
    "descricao" TEXT NOT NULL,
    "preco" DECIMAL(10,2) NOT NULL,
    "imagem_url" TEXT NOT NULL,
    "quantidade_estoque" INTEGER DEFAULT 0,
    "status" "StatusProduto" NOT NULL DEFAULT 'disponivel',
    "data_criacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_atualizacao" TIMESTAMP(3) NOT NULL,
    "tipo_produto" "TipoProduto" NOT NULL DEFAULT 'experiencia',
    "localizacao" VARCHAR(255),
    "duracao" VARCHAR(50),
    "inclui" TEXT,
    "nao_inclui" TEXT,
    "id_cliente_produto" INTEGER,

    CONSTRAINT "produtos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reservas" (
    "id" SERIAL NOT NULL,
    "data_reserva" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_checkin" TIMESTAMP(3),
    "data_checkout" TIMESTAMP(3),
    "quantidade" INTEGER NOT NULL,
    "preco_total" DECIMAL(10,2) NOT NULL,
    "status" "StatusReserva" NOT NULL DEFAULT 'pendente',
    "forma_pagamento" "FormaPagamento",
    "codigo_reserva" VARCHAR(50) NOT NULL,
    "observacoes" TEXT,
    "id_cliente" INTEGER NOT NULL,
    "id_produto" INTEGER NOT NULL,

    CONSTRAINT "reservas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pagamentos" (
    "id" SERIAL NOT NULL,
    "valor" DECIMAL(10,2) NOT NULL,
    "forma_pagamento" "FormaPagamento" NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "transacao_id" VARCHAR(255),
    "data_pagamento" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "comprovante_url" TEXT,
    "id_reserva" INTEGER NOT NULL,

    CONSTRAINT "pagamentos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "avaliacoes" (
    "id" SERIAL NOT NULL,
    "nota" INTEGER NOT NULL,
    "comentario" TEXT,
    "data_criacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_atualizacao" TIMESTAMP(3) NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "id_produto" INTEGER NOT NULL,

    CONSTRAINT "avaliacoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "favoritos" (
    "id" SERIAL NOT NULL,
    "data_criacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_cliente" INTEGER NOT NULL,
    "id_produto" INTEGER NOT NULL,

    CONSTRAINT "favoritos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usuarios_admin" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "senha" VARCHAR(255) NOT NULL,
    "tipo" "TipoAdmin" NOT NULL DEFAULT 'moderador',
    "data_criacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_atualizacao" TIMESTAMP(3) NOT NULL,
    "ultimo_login" TIMESTAMP(3),
    "status" "StatusConta" NOT NULL DEFAULT 'ativo',
    "permissoes" TEXT[],

    CONSTRAINT "usuarios_admin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "logs_acesso" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER,
    "usuario_tipo" VARCHAR(50) NOT NULL,
    "acao" VARCHAR(100) NOT NULL,
    "ip" VARCHAR(45),
    "user_agent" TEXT,
    "data_acesso" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "logs_acesso_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "registro_clientes_email_key" ON "registro_clientes"("email");

-- CreateIndex
CREATE UNIQUE INDEX "registro_clientes_cpf_key" ON "registro_clientes"("cpf");

-- CreateIndex
CREATE INDEX "registro_clientes_email_idx" ON "registro_clientes"("email");

-- CreateIndex
CREATE INDEX "registro_clientes_status_conta_idx" ON "registro_clientes"("status_conta");

-- CreateIndex
CREATE INDEX "registro_clientes_tipo_usuario_idx" ON "registro_clientes"("tipo_usuario");

-- CreateIndex
CREATE INDEX "produtos_tipo_produto_idx" ON "produtos"("tipo_produto");

-- CreateIndex
CREATE INDEX "produtos_status_idx" ON "produtos"("status");

-- CreateIndex
CREATE INDEX "produtos_categoria_idx" ON "produtos"("categoria");

-- CreateIndex
CREATE INDEX "produtos_preco_idx" ON "produtos"("preco");

-- CreateIndex
CREATE UNIQUE INDEX "reservas_codigo_reserva_key" ON "reservas"("codigo_reserva");

-- CreateIndex
CREATE INDEX "reservas_id_cliente_idx" ON "reservas"("id_cliente");

-- CreateIndex
CREATE INDEX "reservas_id_produto_idx" ON "reservas"("id_produto");

-- CreateIndex
CREATE INDEX "reservas_status_idx" ON "reservas"("status");

-- CreateIndex
CREATE INDEX "reservas_data_reserva_idx" ON "reservas"("data_reserva");

-- CreateIndex
CREATE UNIQUE INDEX "pagamentos_transacao_id_key" ON "pagamentos"("transacao_id");

-- CreateIndex
CREATE UNIQUE INDEX "pagamentos_id_reserva_key" ON "pagamentos"("id_reserva");

-- CreateIndex
CREATE INDEX "pagamentos_status_idx" ON "pagamentos"("status");

-- CreateIndex
CREATE INDEX "pagamentos_data_pagamento_idx" ON "pagamentos"("data_pagamento");

-- CreateIndex
CREATE INDEX "avaliacoes_nota_idx" ON "avaliacoes"("nota");

-- CreateIndex
CREATE INDEX "avaliacoes_id_produto_idx" ON "avaliacoes"("id_produto");

-- CreateIndex
CREATE UNIQUE INDEX "avaliacoes_id_cliente_id_produto_key" ON "avaliacoes"("id_cliente", "id_produto");

-- CreateIndex
CREATE INDEX "favoritos_id_cliente_idx" ON "favoritos"("id_cliente");

-- CreateIndex
CREATE UNIQUE INDEX "favoritos_id_cliente_id_produto_key" ON "favoritos"("id_cliente", "id_produto");

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_admin_email_key" ON "usuarios_admin"("email");

-- CreateIndex
CREATE INDEX "usuarios_admin_email_idx" ON "usuarios_admin"("email");

-- CreateIndex
CREATE INDEX "usuarios_admin_status_idx" ON "usuarios_admin"("status");

-- CreateIndex
CREATE INDEX "logs_acesso_usuario_id_idx" ON "logs_acesso"("usuario_id");

-- CreateIndex
CREATE INDEX "logs_acesso_data_acesso_idx" ON "logs_acesso"("data_acesso");

-- CreateIndex
CREATE INDEX "logs_acesso_acao_idx" ON "logs_acesso"("acao");

-- AddForeignKey
ALTER TABLE "produtos" ADD CONSTRAINT "produtos_id_cliente_produto_fkey" FOREIGN KEY ("id_cliente_produto") REFERENCES "registro_clientes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas" ADD CONSTRAINT "reservas_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "registro_clientes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas" ADD CONSTRAINT "reservas_id_produto_fkey" FOREIGN KEY ("id_produto") REFERENCES "produtos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagamentos" ADD CONSTRAINT "pagamentos_id_reserva_fkey" FOREIGN KEY ("id_reserva") REFERENCES "reservas"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "avaliacoes" ADD CONSTRAINT "avaliacoes_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "registro_clientes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "avaliacoes" ADD CONSTRAINT "avaliacoes_id_produto_fkey" FOREIGN KEY ("id_produto") REFERENCES "produtos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favoritos" ADD CONSTRAINT "favoritos_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "registro_clientes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favoritos" ADD CONSTRAINT "favoritos_id_produto_fkey" FOREIGN KEY ("id_produto") REFERENCES "produtos"("id") ON DELETE CASCADE ON UPDATE CASCADE;
