import {Module} from '@nestjs/common';
import {StatisticsService} from './statistics.service';
import {StatisticsController} from './statistics.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
    imports: [TypeOrmModule.forFeature([DataSource])],
    controllers: [StatisticsController],
    providers: [StatisticsService],
})
export class StatisticsModule {
}
