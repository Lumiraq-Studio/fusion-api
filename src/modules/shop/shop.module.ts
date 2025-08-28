import {Module} from '@nestjs/common';
import {ShopService} from './shop.service';
import {ShopController} from './shop.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [ShopController],
  providers: [ShopService],
})
export class ShopModule {}
