import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {CreateProductDTO, UpdateProductDTO} from "./product.entity";
import {processData, processPaginationData} from "../../utils/utils";

@Injectable()
export class ProductService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }


    async  create(createProductDTO:CreateProductDTO){
        const result = await this.dataSourceRepository.query('CALL product_save(?,?,?,?)', [
            createProductDTO.productName,
            createProductDTO.description,
            createProductDTO.warehouseId,
            createProductDTO.createdBy,
        ])
        return processData(result, 0)

    }

    async find(
        productName:string,
        warehouseCode:string,
        items_per_page:number,
        page_number:number

    ) {
        const result = await this.dataSourceRepository.query('CALL product_find(?,?,?,?)',[
            productName,
            warehouseCode,
            +items_per_page,
            +page_number
        ])
        return processPaginationData(result)
    }


    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL product_get_id(?)', [
            id
        ])
        let data = processData(result, 1)
        data.warehouseDetails=JSON.parse(data.warehouseDetails)
        data.variants=JSON.parse(data.variants)
        return data
    }

    async  update(id:number,updateProductDTO:UpdateProductDTO){
        const result = await this.dataSourceRepository.query('CALL product_update(?,?,?,?,?)', [
            id,
            updateProductDTO.productName,
            updateProductDTO.description,
            updateProductDTO.warehouseId,
            updateProductDTO.updatedBy,
        ])
        return processData(result, 0)

    }


    async getPricesByProductAndShop(customerId:number,repId:number) {
        const result = await this.dataSourceRepository.query('CALL price_get_by_shop_id(?,?)', [
            customerId,repId
        ])
        let data = processData(result, 1)
        data.data=JSON.parse(data.data)
        return data
    }

}
