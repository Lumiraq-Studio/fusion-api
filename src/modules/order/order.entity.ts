import {IsArray, IsNumber, IsOptional, IsString, ValidateNested} from "class-validator";
import {Type} from "class-transformer";

export class OrderItemDTO {
    @IsNumber()
    quantity: number;

    @IsNumber()
    variantId: number;

    @IsNumber()
    stockBreakdownId: number;

    @IsNumber()
    price: number;
}

export class CreateOrderDTO {
    @IsString()
    orderDate: string;

    @IsString()
    orderStatus: string;

    @IsString()
    note: string;

    @IsString()
    uuId: string;

    @IsString()
    createdAt: string;

    @IsNumber()
    shopId: number;

    @IsNumber()
    paid: number;

    @IsNumber()
    salesRepId: number;

    @IsNumber()
    paymentTypeId: number;

    @IsString()
    createdBy: string;

    @IsString()
    orderType: string;

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => OrderItemDTO)
    orderItems: OrderItemDTO[];
}


export class UpdateOrderDTO {
    @IsOptional()
    paid:number
    @IsOptional()
    updatedBy:string
}