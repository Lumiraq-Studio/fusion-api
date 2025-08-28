import {BaseEntity, Column, CreateDateColumn, Entity, ManyToOne, PrimaryGeneratedColumn} from 'typeorm';
import {VariantStock} from "./variant-stocks.schema";

@Entity('tbl_stock_history')
export class StockHistory extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    addedDate: string;

    @Column()
    stockQty: number;

    @Column()
    basePrice: number;

    @Column({default: 0})
    availableQty: number;

    @Column({default: 0})
    returnQty: number;

    @Column({default: 0})
    disposeQty: number;

    @CreateDateColumn()
    createdAt: Date;

    @ManyToOne(() => VariantStock, (variantStock) => variantStock.stockHistories, {onDelete: 'CASCADE'})
    variantStock: VariantStock;

}
