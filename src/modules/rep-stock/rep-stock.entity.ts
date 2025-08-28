import {IsArray, IsInt, IsOptional, IsString, ValidateNested} from 'class-validator';
import {Type} from 'class-transformer';

class BreakdownDTO {
    @IsInt()
    breakdownId: number;

    @IsOptional()
    @IsInt()
    variantStockId: number;

    @IsInt()
    assignedQty: number;
}

export class CreateRepStockDTO {
    @IsInt()
    repStockId: number;

    @IsString()
    createdBy: string;

    @IsInt()
    salesRepId: number;

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => BreakdownDTO)
    breakdowns: BreakdownDTO[];
}


export class UnassignRepStockDto {
    updatedBy: string;
}


