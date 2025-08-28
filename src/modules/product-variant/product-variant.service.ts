import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData, processPaginationData} from "../../utils/utils";
import {UpdateBasePriceDTO, UpdateVariantDTO, VariantSaveDTO} from "./varinat.entity";


@Injectable()
export class ProductVariantService {
    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createProductVariant: VariantSaveDTO) {
        const result = await this.dataSourceRepository.query('CALL variant_save(?)', [
            JSON.stringify(createProductVariant.variants)
        ])
        return processData(result, 0)

    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL product_get_id(?)', [
            id
        ])
        let data = processData(result, 1)
        data.warehouseDetails=JSON.parse(data.warehouseDetails)
        data.variants=JSON.parse(data.variants)
        return processData(result, 1)
    }

    async update(id: number, updateProductVariant: UpdateVariantDTO) {
        const result = await this.dataSourceRepository.query('CALL variant_update(?,?,?,?,?,?)', [
            id,
            updateProductVariant.weight,
            updateProductVariant.unit,
            updateProductVariant.updatedBy,
            updateProductVariant.basePrice,
            updateProductVariant.cost,

        ])
        return processData(result, 0)

    }

    async find(
        searchTerm: string,
        weight: number,
        items_per_page: number,
        page_number: number
    ) {
        const result = await this.dataSourceRepository.query('CALL product__variant_find(?,?,?,?)', [
            searchTerm,
            weight,
            +items_per_page,
            +page_number
        ])
        return processPaginationData(result)
    }

    async priceUpdate(id:number,updateBasePriceDTO:UpdateBasePriceDTO){
        const result = await this.dataSourceRepository.query('CALL variant_price_update(?,?,?,?,?)',[
            id,
            updateBasePriceDTO.updatedBy,
            updateBasePriceDTO.basePrice,
            updateBasePriceDTO.cost,
            updateBasePriceDTO.weight,
        ])
        return processData(result,1)
    }
}
