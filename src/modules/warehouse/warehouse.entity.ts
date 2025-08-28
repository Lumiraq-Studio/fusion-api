import {IsOptional} from "class-validator";

export class CreateWarehouseDTO {
    @IsOptional()
    code: string;
    name: string;
    address: string;
    contactPerson: string;
    mobile: string;
    created_by: string;
}

export class UpdateWarehouseDTO extends CreateWarehouseDTO {
}