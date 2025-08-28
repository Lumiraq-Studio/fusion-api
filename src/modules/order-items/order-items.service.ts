import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData, processPaginationData} from "../../utils/utils";
import {CreateOrderItem, UpdatedItemDTO} from "./order-item.entity";

@Injectable()
export class OrderItemsService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createOrderItem: CreateOrderItem) {
        const result = await this.dataSourceRepository.query('CALL shop_save(?,?,?,?,?)', [
            createOrderItem.orderId,
            createOrderItem.variant,
            createOrderItem.price,
            createOrderItem.quantity,
            createOrderItem.createdBy
        ])
        return processData(result, 0)
    }

    async find(
        product_name: string,
        order_reference: string,
        itemsPerPage: number,
        pageNumber: number
    ) {
        const result = await this.dataSourceRepository.query('CALL order_item_find(?,?,?,?)', [
            product_name,
            order_reference,
            itemsPerPage,
            pageNumber
        ])
        return processPaginationData(result)
    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL order_item_get_id(?)', [
            id
        ])
        return processData(result, 1)
    }

    async update(id: number, updatedItemDTO: UpdatedItemDTO) {
        const result = await this.dataSourceRepository.query('CALL shop_save(?,?,?,?)', [
            id,
            updatedItemDTO.price,
            updatedItemDTO.quantity,
            updatedItemDTO.updatedBy,
        ])
        return processData(result, 0)
    }

}
