import {IsNumber, IsOptional, IsString} from "class-validator";

export class CreateProductDTO {
    @IsString()
    productName: string;

    @IsOptional()
    @IsString()
    description: string;

    @IsNumber()
    warehouseId: number;

    @IsString()
    createdBy: string;
}

export class UpdateProductDTO {
    @IsOptional()
    @IsString()
    productName: string;
    @IsOptional()
    @IsString()
    description: string;
    @IsOptional()
    @IsNumber()
    warehouseId: number;
    @IsOptional()
    @IsString()
    updatedBy: number
}