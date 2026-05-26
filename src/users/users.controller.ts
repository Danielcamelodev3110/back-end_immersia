import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseIntPipe,
  UnauthorizedException, // 👈 Importado para o erro de login inválido
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt'; // 👈 Importado para comparar a senha criptografada

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  // 👇 ROTA DE LOGIN CORRIGIDA (POST /users/login)
  @Post('login')
  async login(@Body() loginDto: any) {
    const { email, senha } = loginDto;

    // Busca o usuário no banco incluindo a senha_hash
    const user = await this.usersService.findByEmailWithPassword(email);
    if (!user) {
      throw new UnauthorizedException('E-mail ou senha incorretos.');
    }

    // Compara a senha enviada com o hash salvo no banco
    const passwordMatch = await bcrypt.compare(senha, user.senha_hash);
    if (!passwordMatch) {
      throw new UnauthorizedException('E-mail ou senha incorretos.');
    }

    // 👇 Desestruturação estável: separa a senha_hash e extrai apenas o resto para o 'sanitizedUser'
    const { senha_hash, ...sanitizedUser } = user;

    return {
      message: 'Login realizado com sucesso!',
      user: sanitizedUser,
    };
  }

  @Get()
  findAll() {
    return this.usersService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.usersService.findOne(id);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.usersService.update(id, updateUserDto);
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.usersService.remove(id);
  }
}
