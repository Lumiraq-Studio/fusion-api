import {Controller, Get} from '@nestjs/common';
import {ScreenService} from './screen.service';

@Controller()
export class ScreenController {
    constructor(private readonly screenService: ScreenService) {
    }


    @Get('customers')
    async getCustomers() {
        return await this.screenService.customerDetails();
    }

    @Get('sales-team')
    async getSalesRep() {
        return await this.screenService.salesTeamDetails();
    }

}
