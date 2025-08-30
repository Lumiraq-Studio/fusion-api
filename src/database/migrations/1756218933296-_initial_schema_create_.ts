import { MigrationInterface, QueryRunner } from "typeorm";

export class _initialSchemaCreate_1756218933296 implements MigrationInterface {
    name = '_initialSchemaCreate_1756218933296'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`tbl_expense\` ADD \`incomeAmount\` int NOT NULL DEFAULT '0'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE \`tbl_expense\` DROP COLUMN \`incomeAmount\``);
    }

}
