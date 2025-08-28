import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData} from "../../utils/utils";
import {CreatePricesDTO, UpdateShopPricesDTO} from "./shop-prices.entity";

@Injectable()
export class ShopPricesService {
    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createShopPricesDTO: CreatePricesDTO) {
        const result = await this.dataSourceRepository.query('CALL shop_product_price_save(?)', [
            JSON.stringify(createShopPricesDTO.shopPrices)
        ])
        return processData(result, 0)
    }

    // async find(
    //     price_value: number,
    //     qty_price_flag: number,
    //     product_name: string,
    //     shop_name: string,
    //     itemsPerPage: number,
    //     pageNumber: number
    // ) {
    //     const result = await this.dataSourceRepository.query('CALL shop_price_find(?,?,?,?,?,?)', [
    //         price_value,
    //         qty_price_flag,
    //         product_name,
    //         shop_name,
    //         itemsPerPage,
    //         pageNumber
    //     ])
    //     return processPaginationData(result)
    // }
    //
    // async priceGetByProduct(id: number) {
    //     const result = await this.dataSourceRepository.query('CALL price_get_by_product_id(?)', [
    //         id
    //     ])
    //     let data = processData(result, 1)
    //     data.productDetails = JSON.parse(data.productDetails)
    //     return data
    // }


    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL price_get_id(?)', [
            id
        ])
        return processData(result, 1)
    }

    async update(id:number,updateShopPricesDTO: UpdateShopPricesDTO) {
        const result = await this.dataSourceRepository.query('CALL shop_product_price_update(?,?,?,?,?)', [
            id,
            updateShopPricesDTO.shopId,
            updateShopPricesDTO.variantId,
            updateShopPricesDTO.updatedBY,
            updateShopPricesDTO.status
        ])
        return processData(result, 0)
    }

    async  getByRoutes(id:number){
        const result = await this.dataSourceRepository.query('CALL price_for_route(?)',[
            id
        ])
        let data= processData(result,0)
        data = data.map((shop: any) => {
            return {
                ...shop,
                variantPrices: JSON.parse(shop.variantPrices)
            };
        });
        return data
    }
}
