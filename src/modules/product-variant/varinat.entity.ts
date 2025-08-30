import {IsNotEmpty, IsNumber, IsOptional, IsString} from "class-validator";


export class VariantDto {
    @IsNotEmpty()
    weight: number;

    @IsNotEmpty()
    @IsNumber()
    basePrice: number;

    @IsNotEmpty()
    @IsNumber()
    cost: number;

    @IsNotEmpty()
    @IsNumber()
    productId: number;


    @IsNotEmpty()
    productName: string;

    @IsNotEmpty()
    createdBy: string;

    @IsOptional()
    @IsString()
    unit?: string;
}

export class VariantSaveDTO {
    @IsNotEmpty()
    variants: VariantDto[];
}


export class UpdateVariantDTO {


    @IsOptional()
    @IsNumber()
    weight: number;

    @IsOptional()
    @IsString()
    unit?: string;

    @IsNotEmpty()
    @IsString()
    updatedBy: string;

    @IsOptional()
    @IsNumber()
    basePrice: number;

    @IsOptional()
    @IsNumber()
    cost: number;
}

export class UpdateBasePriceDTO {
    @IsOptional()
    @IsNumber()
    weight: number;

    @IsNotEmpty()
    @IsString()
    updatedBy: string;

    @IsOptional()
    @IsNumber()
    basePrice: number;

    @IsOptional()
    @IsNumber()
    cost: number;
}