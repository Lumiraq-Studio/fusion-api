import {Module} from '@nestjs/common';
import {SalesRepService} from './sales-rep.service';
import {SalesRepController} from './sales-rep.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [SalesRepController],
  providers: [SalesRepService],
})
export class SalesRepModule {}
