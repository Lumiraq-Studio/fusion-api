import {Module} from '@nestjs/common';
import {ProductVariantService} from './product-variant.service';
import {ProductVariantController} from './product-variant.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [ProductVariantController],
  providers: [ProductVariantService],
})
export class ProductVariantModule {}
