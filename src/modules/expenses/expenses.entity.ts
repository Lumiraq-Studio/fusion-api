import {IsNotEmpty, IsNumber, IsOptional, IsString} from 'class-validator';

export class CreateExpenseDTO {
    @IsString()
    @IsNotEmpty()
    description: string;

    @IsString()
    @IsNotEmpty()
    type: string;

    @IsNumber()
    amount: number;

    @IsOptional()
    @IsNumber()
    salesRepId: number;

    @IsString()
    @IsNotEmpty()
    createdBy: string;
}

export class UpdateExpenseDto {

    @IsOptional()
    @IsString()
    description: string;

    @IsNumber({ maxDecimalPlaces: 2 })
    amount: number;

    @IsOptional()
    @IsNumber()
    salesRepId: number;

    @IsString()
    updatedBy: string;
}