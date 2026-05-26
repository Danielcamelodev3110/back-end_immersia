import { TipoUsuario, StatusConta } from '@prisma/client';

export class CreateUserDto {
  nome_completo: string;
  email: string;
  senha: string; // Recebemos como texto puro para hashear no service
  cpf?: string;
  tipo_usuario?: TipoUsuario; // cliente, administrador ou anfitriao
  status_conta?: StatusConta;
  data_nascimento?: string | Date;
  telefone?: string;
  avatar_url?: string;
  bio?: string;
}
