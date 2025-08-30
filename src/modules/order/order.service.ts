import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData, processPaginationData} from "../../utils/utils";
import {CreateOrderDTO, UpdateOrderDTO} from "./order.entity";

@Injectable()
export class OrderService {
    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createOrderDTO: CreateOrderDTO) {
        const result = await this.dataSourceRepository.query(
            'CALL order_save(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
                createOrderDTO.orderDate,
                createOrderDTO.orderStatus,
                createOrderDTO.note,
                createOrderDTO.uuId,
                createOrderDTO.createdAt,
                createOrderDTO.shopId,
                createOrderDTO.paid,
                createOrderDTO.salesRepId,
                createOrderDTO.paymentTypeId,
                createOrderDTO.createdBy,
                createOrderDTO.orderType,
                JSON.stringify(createOrderDTO.orderItems),
            ]
        );
        return processData(result, 0);
    }


    async find(
        order_type: string,
        order_date: string,
        orderStatus: string,
        order_reference: string,
        shop_name: string,
        sales_rep_name: string,
        payment_type: string,
        routeId: number,
        itemsPerPage: number,
        pageNumber: number
    ) {
        const result = await this.dataSourceRepository.query('CALL order_find(?,?,?,?,?,?,?,?,?,?)', [
            order_date,
            order_type,
            orderStatus,
            order_reference,
            shop_name,
            sales_rep_name,
            payment_type,
            +routeId,
            itemsPerPage,
            pageNumber
        ])
        return processPaginationData(result)
    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL order_get_id(?)', [
            id
        ])

        let data = processData(result, 1)
        // data.shopDetails = JSON.parse(data.shopDetails)
        data.orderItems = JSON.parse(data.orderItems)
        return data
    }

    async update(id: number, updateOrderDTO: UpdateOrderDTO) {
        const result = await this.dataSourceRepository.query('CALL order_update(?,?,?)', [
            id,
            updateOrderDTO.paid,
            updateOrderDTO.updatedBy,
        ])
        return processData(result, 0)
    }

    async getTodayCash(dateValue: string) {
        const result = await this.dataSourceRepository.query('CALL get_today_order_details(?)', [
            dateValue
        ])
        return processData(result, 0)
    }


}
