import {Module} from '@nestjs/common';
import {VariantStocksService} from './variant-stocks.service';
import {VariantStocksController} from './variant-stocks.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [VariantStocksController],
  providers: [VariantStocksService],
})
export class VariantStocksModule {}
