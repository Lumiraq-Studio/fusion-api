import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {CreateExpenseDTO, UpdateExpenseDto} from "./expenses.entity";
import {processData, processPaginationData} from "../../utils/utils";


@Injectable()
export class ExpensesService {


    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createExpenseDto: CreateExpenseDTO) {
        try {
            const result = await this.dataSourceRepository.query(
                'CALL expense_save(?, ?,?, ?, ?)',
                [createExpenseDto.description, createExpenseDto.type, createExpenseDto.amount, createExpenseDto.salesRepId, createExpenseDto.createdBy],
            );
            return processData(result, 1);
        } catch (error) {
            throw new Error(`Expense creation failed: ${error.message}`);
        }
    }

    async update(id: number, createExpenseDto: UpdateExpenseDto) {
        try {
            const result = await this.dataSourceRepository.query(
                'CALL expense_update(?, ?, ?, ?,?)',
                [
                    id,
                    createExpenseDto.description,
                    createExpenseDto.amount,
                    createExpenseDto.salesRepId,
                    createExpenseDto.updatedBy],
            );
            return processData(result, 1);
        } catch (error) {
            throw new Error(`Expense creation failed: ${error.message}`);
        }
    }

    async find(
        salesRepId: number,
        expensesDate: string,
        itemsPerPage: number,
        pageNumber: number
    ) {
        const result = await this.dataSourceRepository.query(
            `CALL expenses_find(?, ?, ?, ?)`,
            [salesRepId, expensesDate, itemsPerPage, pageNumber]
        );
      return   processPaginationData(result)
    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL expenses_get(?)', [
            id
        ])
        let data = processData(result, 1)
        data.salesRep = JSON.parse(data.salesRep)
        return data
    }

    async getSummary(){
        const result = await this.dataSourceRepository.query('CALL today_cash_summary()')
        let data = processData(result, 1)
        // data.salesRep = JSON.parse(data.salesRep)
        return data
    }

}
