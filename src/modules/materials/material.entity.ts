import { IsString, IsNotEmpty, IsNumber, IsOptional, Min } from 'class-validator';

export class CreateMaterialDTO {
    @IsString()
    @IsNotEmpty()
    name: string;

    @IsNumber()
    unitCost: number;

    @IsNumber()
    @IsOptional()
    quantity?: number;

    @IsNumber()
    @IsOptional()
    availableQty?: number;
}

export class UpdateMaterialDTO {
    @IsString()
    @IsOptional()
    name?: string;

    @IsNumber()
    @IsOptional()
    @Min(0)
    unitCost?: number;

    @IsNumber()
    @IsOptional()
    @Min(0)
    quantity?: number;

    @IsNumber()
    @IsOptional()
    @Min(0)
    availableQty?: number;
}