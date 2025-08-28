import {Module} from '@nestjs/common';
import {ScreenService} from './screen.service';
import {ScreenController} from './screen.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [ScreenController],
  providers: [ScreenService],
})
export class ScreenModule {}
