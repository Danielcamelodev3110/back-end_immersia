import {
  IsNotEmpty,
  IsNumber,
  IsString,
  IsOptional,
  Min,
} from 'class-validator';

export class CreateProdutoDto {
  @IsString()
  @IsNotEmpty({ message: 'O título do produto é obrigatório.' })
  titulo: string;

  @IsString()
  @IsNotEmpty({ message: 'A descrição do produto é obrigatória.' })
  descricao: string;

  @IsNumber()
  @Min(0, { message: 'O preço não pode ser menor que zero.' })
  preco: number;

  @IsString()
  @IsOptional()
  localizacao?: string;

  @IsNumber()
  @IsNotEmpty({ message: 'O ID do anfitrião proprietário é necessário.' })
  anfitriaoId: number;
}
