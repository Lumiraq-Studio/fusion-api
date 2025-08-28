import {Routes} from '@nestjs/core'
import {UserModule} from "./src/modules/user/user.module";
import {OrderModule} from "./src/modules/order/order.module";
import {OrderItemsModule} from "./src/modules/order-items/order-items.module";
import {RouteModule} from "./src/modules/route/route.module";
import {ShopModule} from "./src/modules/shop/shop.module";
import {ShopPricesModule} from "./src/modules/shop-prices/shop-prices.module";
import {ProductModule} from "./src/modules/product/product.module";
import {SalesRepModule} from "./src/modules/sales-rep/sales-rep.module";
import {PaymentTermsModule} from "./src/modules/payment-terms/payment-terms.module";
import {ProductVariantModule} from "./src/modules/product-variant/product-variant.module";
import {RepStockModule} from "./src/modules/rep-stock/rep-stock.module";
import {WarehouseModule} from "./src/modules/warehouse/warehouse.module";
import {VariantStocksModule} from "./src/modules/variant-stocks/variant-stocks.module";
import {ScreenModule} from "./src/modules/screen/screen.module";
import {AuthModule} from "./src/modules/auth/auth.module";
import {SysUserModule} from "./src/modules/sys-user/sys-user.module";
import {ReportModule} from "./src/modules/report/report.module";
import {ExpensesModule} from "./src/modules/expenses/expenses.module";
import {MaterialsService} from "./src/modules/materials/materials.service";


export const routes: Routes = [
    { path: 'user', module: UserModule },
    { path: 'order', module: OrderModule },
    { path: 'order-item', module: OrderItemsModule },
    { path: 'route', module: RouteModule },
    { path: 'customer', module: ShopModule },
    { path: 'price', module: ShopPricesModule },
    { path: 'product', module: ProductModule },
    { path: 'sales-rep', module: SalesRepModule },
    { path: 'payments-terms', module: PaymentTermsModule },
    { path: 'variant', module: ProductVariantModule },
    { path: 'sales-person-stock', module: RepStockModule },
    { path: 'warehouse', module: WarehouseModule },
    { path: 'variant-stock', module: VariantStocksModule },
    { path: 'summary', module: ScreenModule },
    { path: 'auth', module: AuthModule },
    { path: 'sys-user', module: SysUserModule },
    { path: 'reports', module: ReportModule },
    { path: 'expenses', module: ExpensesModule },
    { path: 'materials', module: MaterialsService },
];
