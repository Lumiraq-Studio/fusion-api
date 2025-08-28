import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData} from "../../utils/utils";
import {CreateVariantStock} from "./variant-stock.entity";

@Injectable()
export class VariantStocksService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createVariantStock: CreateVariantStock) {
        const result = await this.dataSourceRepository.query('CALL variant_stock_save(?,?,?,?,?)', [
            createVariantStock.stockId,
            createVariantStock.stockQty,
            createVariantStock.createdBy,
            createVariantStock.variantId,
            createVariantStock.warehouseId
        ])
        return processData(result, 0)
    }


    async variant_stock_get_by_product(id: number) {
        const result = await this.dataSourceRepository.query('CALL variant_stock_get_by_product(?)', [
            id
        ])
        return processData(result, 0)
    }
}
