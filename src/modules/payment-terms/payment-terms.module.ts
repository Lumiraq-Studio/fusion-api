import {Module} from '@nestjs/common';
import {PaymentTermsService} from './payment-terms.service';
import {PaymentTermsController} from './payment-terms.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {DataSource} from "typeorm";

@Module({
  imports: [TypeOrmModule.forFeature([DataSource])],
  controllers: [PaymentTermsController],
  providers: [PaymentTermsService],
})
export class PaymentTermsModule {}
