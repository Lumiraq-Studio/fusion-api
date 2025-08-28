import {IsOptional} from "class-validator";

export class CreateShopDTO {
    fullName: string
    shortName: string
    address: string
    city: string
    mobile: string
    routeId: number
    shopType: number
    createdBy: number
}

export class UpdateShopDTO {
   @IsOptional()
    fullName: string
    @IsOptional()
    shortName: string
    @IsOptional()
    address: string
    @IsOptional()
    status: string
    @IsOptional()
    mobile: string
    @IsOptional()
    routeId: number
    @IsOptional()
    shopType: number
    @IsOptional()
    updatedBy: number
}