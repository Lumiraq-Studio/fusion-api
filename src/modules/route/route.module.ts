import {Module} from '@nestjs/common';
import {RouteService} from './route.service';
import {RouteController} from './route.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [RouteController],
  providers: [RouteService],
})
export class RouteModule {}
