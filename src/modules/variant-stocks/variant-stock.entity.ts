import {IsNotEmpty, IsOptional} from "class-validator";

export class CreateVariantStock {
    @IsOptional()
    stockId: number
    @IsNotEmpty()
    stockQty: number
    @IsNotEmpty()
    createdBy: string
    @IsNotEmpty()
    variantId: number
    @IsNotEmpty()
    warehouseId: number
}