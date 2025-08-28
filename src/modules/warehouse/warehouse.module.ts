import {Module} from '@nestjs/common';
import {WarehouseService} from './warehouse.service';
import {WarehouseController} from './warehouse.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [WarehouseController],
  providers: [WarehouseService],
})
export class WarehouseModule {}
