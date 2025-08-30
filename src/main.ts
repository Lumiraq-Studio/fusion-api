import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as compression from 'compression';
import helmet from 'helmet';
import * as cookieParser from 'cookie-parser';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  const configService = app.get(ConfigService);
  const port = configService.get<number>('PORT') || 3000;
  const globalPrefix = configService.get<string>('GLOBAL_PREFIX');
  // Enable shutdown hooks
  app.enableShutdownHooks();
  // Global route prefix
  app.setGlobalPrefix(globalPrefix);
  // Security headers
  app.use(helmet());
  // Response compression
  app.use(compression());
  // Cookie
  app.use(cookieParser());
  // CORS
  app.enableCors({
    origin: configService.get<string>('CORS_ORIGIN') || '*',
    credentials: true,
  });
  //Validation pipe
  app.useGlobalPipes()
  await app.listen(port);
  logger.log(`Application is running on: http://localhost:${port}`);
  const shutdown = async (signal: string) => {
    logger.warn(`${signal} received. Closing application gracefully...`);
    await app.close();
    process.exit(0);
  };

  process.on('SIGINT', () => shutdown('SIGINT'));
  process.on('SIGTERM', () => shutdown('SIGTERM'));
}
bootstrap();
