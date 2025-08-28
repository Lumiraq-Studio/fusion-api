import {Module} from '@nestjs/common';
import {ShopPricesService} from './shop-prices.service';
import {ShopPricesController} from './shop-prices.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [ShopPricesController],
  providers: [ShopPricesService],
})
export class ShopPricesModule {}
