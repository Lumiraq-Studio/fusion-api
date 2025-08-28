import {Type} from "class-transformer";
import {IsNotEmpty, IsNumber, IsString} from "class-validator";

export class ShopPriceDto {
    @IsNumber()
    @IsNotEmpty()
    shopId: number;

    @IsNumber()
    @IsNotEmpty()
    variantId: number;

    @IsNumber()
    @IsNotEmpty()
    priceValue: number;


    @IsNotEmpty()
    createdBy: string;
}

export class CreatePricesDTO {
    @Type(() => ShopPriceDto)
    shopPrices: ShopPriceDto[];
}



export class UpdateShopPricesDTO {
    @IsNumber()
    @IsNotEmpty()
    shopId: number;

    @IsNumber()
    @IsNotEmpty()
    variantId: number;

    @IsNotEmpty()
    updatedBY: string;

    @IsString()
    @IsNotEmpty()
    status: string;
}