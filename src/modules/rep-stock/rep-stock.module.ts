import {Module} from '@nestjs/common';
import {RepStockService} from './rep-stock.service';
import {RepStockController} from './rep-stock.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";
import {VariantStock} from "../../schemas/variant-stocks.schema";
import {SalesRepStock} from "../../schemas/sales_rep_stock.schema";
import {SalesRepStockBreakdown} from "../../schemas/sales_rep_stock_breakdowns.schema";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource,VariantStock,SalesRepStock,SalesRepStockBreakdown])],
  controllers: [RepStockController],
  providers: [RepStockService],
})
export class RepStockModule {}
