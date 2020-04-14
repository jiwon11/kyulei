const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const morgan = require('morgan');
const session = require('express-session');
const flash = require('connect-flash');
const bodyParser = require('body-parser');
const passport = require('passport');
require('dotenv').config();
const { sequelize } = require('./models');

var indexRouter = require('./routes/index');
var authRouter = require('./routes/auth');
var collectionRouter = require('./routes/collections');
var crwalsetRouter = require('./routes/crwalset');
var calendarRouter = require('./routes/calendar');
const passportConfig = require('./passport');

var app = express();
sequelize.sync({});
passportConfig(passport);
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.engine('html',require('ejs').renderFile);
app.set('port',process.env.PORT || 3000);

app.use(express.json());
app.use(express.urlencoded({extended: false }));


app.use(morgan('dev'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(cookieParser(process.env.COOKIE_SECRET));
app.use(session({
  resave: false,
  saveUninitialized: true,
  secret : process.env.COOKIE_SECRET,
  cookie: {
    httpOnly: true,
    secure: false,
  },
}));
app.use(flash());
app.use(passport.initialize());
app.use(passport.session());

app.use('/', indexRouter);
app.use('/auth', authRouter);
app.use('/collections', collectionRouter);
app.use('/crwalset', crwalsetRouter);
app.use('/calendar', calendarRouter);
// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});
// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

app.listen(app.get('port'),() => {
  console.log(app.get('port'),'번 포트에서 대기중');
});
