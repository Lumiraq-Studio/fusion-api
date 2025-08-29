import {Module} from '@nestjs/common'
import {AppController} from './app.controller'
import {AppService} from './app.service'
import {ConfigModule} from '@nestjs/config'
import {APP_INTERCEPTOR, RouterModule} from '@nestjs/core'
import {routes} from '../routes'
import {EventEmitterModule} from "@nestjs/event-emitter";
import {dataSourceOptions} from "./config/typeorm.config";
import {TypeOrmModule} from "@nestjs/typeorm";
import {ResponseInterceptor} from "./interceptor/response.interceptor";
import {RequestInterceptor} from "./interceptor/request.interceptor";
import {WarehouseModule} from "./modules/warehouse/warehouse.module";
import {UserModule} from "./modules/user/user.module";
import {OrderModule} from "./modules/order/order.module";
import {OrderItemsModule} from "./modules/order-items/order-items.module";
import {RouteModule} from "./modules/route/route.module";
import {ShopModule} from "./modules/shop/shop.module";
import {ShopPricesModule} from "./modules/shop-prices/shop-prices.module";
import {ProductModule} from "./modules/product/product.module";
import {SalesRepModule} from "./modules/sales-rep/sales-rep.module";
import {PaymentTermsModule} from "./modules/payment-terms/payment-terms.module";
import {ProductVariantModule} from "./modules/product-variant/product-variant.module";
import {RepStockModule} from "./modules/rep-stock/rep-stock.module";
import {VariantStocksModule} from "./modules/variant-stocks/variant-stocks.module";
import {ScreenModule} from "./modules/screen/screen.module";
import {VehicleModule} from "./modules/vehicle/vehicle.module";
import {AuthModule} from "./modules/auth/auth.module";
import {SysUserModule} from "./modules/sys-user/sys-user.module";
import {ReportModule} from "./modules/report/report.module";
import {ExpensesModule} from "./modules/expenses/expenses.module";
import {MaterialsModule} from "./modules/materials/materials.module";
import {StatisticsModule} from "./modules/statistics/statistics.module";


@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
            envFilePath: '.env',

        }),
        TypeOrmModule.forRoot(dataSourceOptions),
        RouterModule.register(routes),
        EventEmitterModule.forRoot(),
        WarehouseModule,
        UserModule,
        VehicleModule,
        OrderModule,
        OrderItemsModule,
        RouteModule,
        ShopModule,
        ShopPricesModule,
        ProductModule,
        SalesRepModule,
        PaymentTermsModule,
        ProductVariantModule,
        RepStockModule,
        VariantStocksModule,
        ScreenModule,
        AuthModule,
        SysUserModule,
        ReportModule,
        ExpensesModule,
        MaterialsModule,
        StatisticsModule   
    

    ],
    controllers: [AppController],
    providers: [
        AppService,
        {
            provide: APP_INTERCEPTOR,
            useClass: ResponseInterceptor,
        },
        {
            provide: APP_INTERCEPTOR,
            useClass: RequestInterceptor,
        },
    ],
})
export class AppModule {
}
