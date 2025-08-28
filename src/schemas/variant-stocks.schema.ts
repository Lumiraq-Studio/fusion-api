import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    ManyToOne,
    OneToMany,
    OneToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';
import {Warehouse} from './warehouse.schema';
import {ProductVariant} from './product-variant.schema';
import {SalesRepStockBreakdown} from "./sales_rep_stock_breakdowns.schema";
import {StockHistory} from "./stock-history.schema";


@Entity('tbl_variant_stock')
export class VariantStock extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    variantRef: string;

    @ManyToOne(() => ProductVariant, (variant) => variant.stocks, { nullable: false })
    variant: ProductVariant;

    @ManyToOne(() => Warehouse, (warehouse) => warehouse.id, { nullable: false })
    warehouse: Warehouse;

    @OneToMany(() => SalesRepStockBreakdown, (breakdown) => breakdown.variantStock)
    breakdowns: SalesRepStockBreakdown[];

    @Column()
    status: string;

    @Column()
    stockQty: number;

    @Column()
    basePrice: number;

    @Column({ default: 0 })
    availableQty: number;

    @Column({ default: 0 })
    returnQty: number;

    @Column({ default: 0 })
    disposeQty: number;

    @Column()
    createdBy: string;

    @Column({ nullable: true })
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({ nullable: true })
    updatedAt: Date;

    @OneToMany(() => StockHistory, (stockHistory) => stockHistory.variantStock)
    stockHistories: StockHistory[];
}
