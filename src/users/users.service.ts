import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    const { senha, email, cpf, data_nascimento, ...rest } = createUserDto;

    // 1. Validação de Email Existente
    const emailExists = await this.prisma.registroCliente.findUnique({
      where: { email },
    });
    if (emailExists) throw new ConflictException('E-mail já cadastrado.');

    // 2. Validação de CPF Existente
    if (cpf) {
      const cpfExists = await this.prisma.registroCliente.findUnique({
        where: { cpf },
      });
      if (cpfExists) throw new ConflictException('CPF já cadastrado.');
    }

    // 3. Criptografia de Senha
    const salt = await bcrypt.genSalt(10);
    const senha_hash = await bcrypt.hash(senha, salt);

    // 4. Tratamento do erro de ISO DateTime do Prisma
    // Se receber apenas YYYY-MM-DD, converte para objeto Date nativo
    const dataConvertida = data_nascimento
      ? new Date(data_nascimento)
      : undefined;

    const user = await this.prisma.registroCliente.create({
      data: {
        ...rest,
        email,
        cpf,
        senha_hash,
        data_nascimento: dataConvertida,
      },
    });

    return this.sanitizeUser(user);
  }

  async findAll() {
    const users = await this.prisma.registroCliente.findMany();
    return users.map((user) => this.sanitizeUser(user));
  }

  async findOne(id: number) {
    const user = await this.prisma.registroCliente.findUnique({
      where: { id },
    });
    if (!user) throw new NotFoundException('Usuário não encontrado.');
    return this.sanitizeUser(user);
  }

  async findByEmailWithPassword(email: string) {
    return this.prisma.registroCliente.findUnique({ where: { email } });
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    await this.findOne(id);

    const dataToUpdate: any = { ...updateUserDto };

    if (updateUserDto.senha) {
      const salt = await bcrypt.genSalt(10);
      dataToUpdate.senha_hash = await bcrypt.hash(updateUserDto.senha, salt);
      delete dataToUpdate.senha;
    }

    if (updateUserDto.data_nascimento) {
      dataToUpdate.data_nascimento = new Date(updateUserDto.data_nascimento);
    }

    const updatedUser = await this.prisma.registroCliente.update({
      where: { id },
      data: dataToUpdate,
    });

    return this.sanitizeUser(updatedUser);
  }

  async remove(id: number) {
    await this.findOne(id);
    return this.prisma.registroCliente.delete({ where: { id } });
  }

  private sanitizeUser(user: any) {
    const sanitized = { ...user };
    delete sanitized.senha_hash;
    return sanitized;
  }
}
