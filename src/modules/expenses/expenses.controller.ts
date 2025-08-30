import {Body, Controller, Get, Param, Post, Put, Query} from '@nestjs/common';
import {ExpensesService} from './expenses.service';
import {CreateExpenseDTO, UpdateExpenseDto} from "./expenses.entity";

@Controller()
export class ExpensesController {
    constructor(private readonly expensesService: ExpensesService) {
    }

    @Get('find')
    async find(
        @Query('salesRepId') salesRepId: number,
        @Query('expensesDate') expensesDate: string,
        @Query('items_per_page') itemsPerPage: number,
        @Query('page_number') pageNumber: number
    ) {
        return await this.expensesService.find(
            +salesRepId,
            expensesDate,
            +itemsPerPage,
            +pageNumber
        );
    }

    @Get('summary')
    async summary() {
        return await this.expensesService.getSummary();
    }

    @Get(':id')
    async get(@Param('id') id: number) {
        return await this.expensesService.get(id);
    }




    @Put(':id')
    async update(
        @Param('id') id: number,
        @Body() updateExpenseDto: UpdateExpenseDto
    ) {
        return await this.expensesService.update(id, updateExpenseDto);
    }

    @Post()
    async createOrder(@Body() createExpenseDTO: CreateExpenseDTO) {
        return await this.expensesService.create(createExpenseDTO);
    }


}
