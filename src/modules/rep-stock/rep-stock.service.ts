import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, MoreThan, Repository} from "typeorm";
import {processData} from "../../utils/utils";
import {CreateRepStockDTO, UnassignRepStockDto} from "./rep-stock.entity";
import {VariantStock} from "../../schemas/variant-stocks.schema";
import {SalesRepStock} from "../../schemas/sales_rep_stock.schema";
import {SalesRepStockBreakdown} from "../../schemas/sales_rep_stock_breakdowns.schema";


@Injectable()
export class RepStockService {
    constructor(
        private dataSource: DataSource,
        @InjectRepository(VariantStock)
        private variantStockRepository: Repository<VariantStock>,
        @InjectRepository(SalesRepStock)
        private salesRepStockRepository: Repository<SalesRepStock>,
        @InjectRepository(SalesRepStockBreakdown)
        private salesRepStockBreakdownRepository: Repository<SalesRepStockBreakdown>
    ) {}


    async save(createRepStockDTO: CreateRepStockDTO) {
        const breakdownsJson = JSON.stringify(createRepStockDTO.breakdowns);
        const result = await this.dataSource.query(
            `CALL new_save_rep_stock_with_breakdowns(?, ?, ?, ?)`,
            [createRepStockDTO.repStockId, createRepStockDTO.createdBy, createRepStockDTO.salesRepId, breakdownsJson],
        );
        return processData(result, 1)
    }


    async getByRep(id: number, assignDate: string) {
        const result = await this.dataSource.query(
            'CALL rep_stock_get_by_rep(?, ?)',
            [id, assignDate]
        );
        const data = processData(result, 1);
        if (!data) {
            return [];
        }
        data.availableStock = data.availableStock ? JSON.parse(data.availableStock) : [];
        return data;
    }


    async get(id: number) {
        const result = await this.dataSource.query('CALL rep_stock_get(?)', [
            id
        ])
        let data = processData(result, 1)
        return data
    }


    async unassignRepStock(RepBreakdownId: number, unassignRepStockDto: UnassignRepStockDto) {
        const result = await this.dataSource.query(
            'CALL remove_assigned_qty(?,?)',
            [+RepBreakdownId, unassignRepStockDto.updatedBy]
        );
        return processData(result, 1);
    }

}
